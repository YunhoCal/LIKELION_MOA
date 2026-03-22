const admin = require('firebase-admin');

// Initialize Firebase Admin SDK (reuse existing initialization)
const serviceAccount = require('./firebase-service-account.json');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();

async function cleanupSampleUsers() {
  try {
    console.log('🧹 Starting cleanup of sample users...\n');

    // Get all users
    const usersSnapshot = await db.collection('users').get();

    console.log(`Found ${usersSnapshot.size} total users`);

    // Sample users have IDs like "user1", "user2", etc.
    // Real users have timestamp-based IDs
    const sampleUsers = [];
    const realUsers = [];

    usersSnapshot.forEach(doc => {
      const user = doc.data();

      // Check if user ID matches sample data pattern (userX)
      if (user.id && user.id.match(/^user\d+$/)) {
        sampleUsers.push({
          id: doc.id,
          name: user.name,
          email: user.email
        });
      } else {
        realUsers.push({
          id: doc.id,
          name: user.name,
          email: user.email
        });
      }
    });

    console.log(`\n📊 Summary:`);
    console.log(`   Sample users: ${sampleUsers.length}`);
    console.log(`   Real users: ${realUsers.length}`);

    if (sampleUsers.length > 0) {
      console.log(`\n🗑️  Deleting sample users:\n`);

      const batch = db.batch();
      let count = 0;

      sampleUsers.forEach(user => {
        console.log(`   - ${user.name} (${user.email})`);
        const userRef = db.collection('users').doc(user.id);
        batch.delete(userRef);
        count++;
      });

      await batch.commit();
      console.log(`\n✅ Deleted ${count} sample users`);
    } else {
      console.log(`\n✅ No sample users to delete`);
    }

    if (realUsers.length > 0) {
      console.log(`\n✨ Keeping ${realUsers.length} real users:\n`);
      realUsers.forEach(user => {
        console.log(`   ✓ ${user.name} (${user.email})`);
      });
    }

    console.log('\n✅ Cleanup completed successfully!');
    process.exit(0);

  } catch (error) {
    console.error('❌ Cleanup failed:', error);
    process.exit(1);
  }
}

cleanupSampleUsers();
