const sqlite3 = require('sqlite3').verbose();
const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase-service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Open SQLite database
const dbPath = path.join(__dirname, 'moa.db');
const sqliteDb = new sqlite3.Database(dbPath);

async function migrateUsers() {
  return new Promise((resolve, reject) => {
    sqliteDb.all('SELECT * FROM users', async (err, users) => {
      if (err) {
        reject(err);
        return;
      }

      console.log(`Found ${users.length} users to migrate`);

      const batch = db.batch();
      let count = 0;

      for (const user of users) {
        const userRef = db.collection('users').doc(user.id);
        batch.set(userRef, {
          id: user.id,
          email: user.email,
          password_hash: user.password_hash,
          name: user.name,
          university: user.university,
          major: user.major || null,
          graduation_year: user.graduation_year || null,
          bio: user.bio || null,
          profile_picture_url: user.profile_picture_url || null,
          created_at: user.created_at ? admin.firestore.Timestamp.fromDate(new Date(user.created_at)) : admin.firestore.FieldValue.serverTimestamp(),
          updated_at: user.updated_at ? admin.firestore.Timestamp.fromDate(new Date(user.updated_at)) : admin.firestore.FieldValue.serverTimestamp()
        });

        count++;

        // Firestore batches are limited to 500 operations
        if (count % 500 === 0) {
          await batch.commit();
          console.log(`Migrated ${count} users...`);
        }
      }

      // Commit any remaining operations
      if (count % 500 !== 0) {
        await batch.commit();
      }

      console.log(`✅ Successfully migrated ${users.length} users`);
      resolve();
    });
  });
}

async function migrateActivities() {
  return new Promise((resolve, reject) => {
    sqliteDb.all('SELECT * FROM activities', async (err, activities) => {
      if (err) {
        reject(err);
        return;
      }

      console.log(`Found ${activities.length} activities to migrate`);

      const batch = db.batch();
      let count = 0;

      for (const activity of activities) {
        const activityRef = db.collection('activities').doc(activity.id);

        // Parse participants JSON
        let participants = [];
        try {
          participants = JSON.parse(activity.participants);
        } catch (e) {
          participants = [];
        }

        batch.set(activityRef, {
          id: activity.id,
          title: activity.title,
          category: activity.category,
          description: activity.description,
          hostUserId: activity.host_user_id,
          hostName: activity.host_name,
          hostUniversity: activity.host_university,
          locationName: activity.location_name,
          locationLat: activity.location_lat,
          locationLng: activity.location_lng,
          startDateTime: admin.firestore.Timestamp.fromDate(new Date(activity.start_date_time)),
          endDateTime: activity.end_date_time ? admin.firestore.Timestamp.fromDate(new Date(activity.end_date_time)) : null,
          isInstant: activity.is_instant === 1,
          maxParticipants: activity.max_participants,
          currentParticipants: activity.current_participants,
          status: activity.status,
          participants: participants,
          createdAt: activity.created_at ? admin.firestore.Timestamp.fromDate(new Date(activity.created_at)) : admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: activity.updated_at ? admin.firestore.Timestamp.fromDate(new Date(activity.updated_at)) : admin.firestore.FieldValue.serverTimestamp()
        });

        count++;

        // Firestore batches are limited to 500 operations
        if (count % 500 === 0) {
          await batch.commit();
          console.log(`Migrated ${count} activities...`);
        }
      }

      // Commit any remaining operations
      if (count % 500 !== 0) {
        await batch.commit();
      }

      console.log(`✅ Successfully migrated ${activities.length} activities`);
      resolve();
    });
  });
}

async function migrate() {
  try {
    console.log('🚀 Starting migration from SQLite to Firebase Firestore...\n');

    await migrateUsers();
    console.log('');
    await migrateActivities();

    console.log('\n✅ Migration completed successfully!');

    sqliteDb.close();
    process.exit(0);
  } catch (error) {
    console.error('❌ Migration failed:', error);
    sqliteDb.close();
    process.exit(1);
  }
}

migrate();
