const admin = require('firebase-admin');

// Initialize Firebase Admin SDK (reuse existing initialization)
const serviceAccount = require('./firebase-service-account.json');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();

async function cleanupSampleActivities() {
  try {
    console.log('🧹 Starting cleanup of sample activities...\n');

    // Get all activities
    const activitiesSnapshot = await db.collection('activities').get();

    console.log(`Found ${activitiesSnapshot.size} total activities`);

    // Sample activities have host_user_id like "user1", "user2", etc.
    // Real users have timestamp-based IDs
    const sampleActivities = [];
    const realActivities = [];

    activitiesSnapshot.forEach(doc => {
      const activity = doc.data();

      // Check if hostUserId matches sample data pattern (userX)
      if (activity.hostUserId && activity.hostUserId.match(/^user\d+$/)) {
        sampleActivities.push({
          id: doc.id,
          title: activity.title,
          hostUserId: activity.hostUserId
        });
      } else {
        realActivities.push({
          id: doc.id,
          title: activity.title,
          hostUserId: activity.hostUserId
        });
      }
    });

    console.log(`\n📊 Summary:`);
    console.log(`   Sample activities: ${sampleActivities.length}`);
    console.log(`   Real activities: ${realActivities.length}`);

    if (sampleActivities.length > 0) {
      console.log(`\n🗑️  Deleting sample activities:\n`);

      const batch = db.batch();
      let count = 0;

      sampleActivities.forEach(activity => {
        console.log(`   - ${activity.title} (host: ${activity.hostUserId})`);
        const activityRef = db.collection('activities').doc(activity.id);
        batch.delete(activityRef);
        count++;
      });

      await batch.commit();
      console.log(`\n✅ Deleted ${count} sample activities`);
    } else {
      console.log(`\n✅ No sample activities to delete`);
    }

    if (realActivities.length > 0) {
      console.log(`\n✨ Keeping ${realActivities.length} real activities:\n`);
      realActivities.forEach(activity => {
        console.log(`   ✓ ${activity.title} (host: ${activity.hostUserId})`);
      });
    }

    console.log('\n✅ Cleanup completed successfully!');
    process.exit(0);

  } catch (error) {
    console.error('❌ Cleanup failed:', error);
    process.exit(1);
  }
}

cleanupSampleActivities();
