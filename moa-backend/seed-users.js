const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const path = require('path');
const crypto = require('crypto');

const dbPath = path.join(__dirname, 'moa.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Database connection failed:', err);
    process.exit(1);
  } else {
    console.log('Database connected at', dbPath);
    seedUsers();
  }
});

function seedUsers() {
  const users = [
    {
      id: 'user1',
      email: 'john.doe@bu.edu',
      password: 'password123',
      name: 'John Doe',
      university: 'Boston University',
      major: 'Computer Science',
      graduationYear: '2025',
      bio: 'CS student passionate about algorithms'
    },
    {
      id: 'user2',
      email: 'jane.smith@bu.edu',
      password: 'password123',
      name: 'Jane Smith',
      university: 'Boston University',
      major: 'Business Administration',
      graduationYear: '2024',
      bio: 'Love trying new restaurants'
    },
    {
      id: 'user3',
      email: 'mike.johnson@bu.edu',
      password: 'password123',
      name: 'Mike Johnson',
      university: 'Boston University',
      major: 'Exercise Science',
      graduationYear: '2025',
      bio: 'Basketball enthusiast'
    },
    {
      id: 'user5',
      email: 'sarah.kim@northeastern.edu',
      password: 'password123',
      name: 'Sarah Kim',
      university: 'Northeastern University',
      major: 'Engineering',
      graduationYear: '2024',
      bio: 'Preparing for grad school'
    },
    {
      id: 'user9',
      email: 'emily.park@mit.edu',
      password: 'password123',
      name: 'Emily Park',
      university: 'MIT',
      major: 'Linguistics',
      graduationYear: '2025',
      bio: 'Language enthusiast'
    },
    {
      id: 'user11',
      email: 'david.lee@harvard.edu',
      password: 'password123',
      name: 'David Lee',
      university: 'Harvard University',
      major: 'Economics',
      graduationYear: '2024',
      bio: 'Foodie and culture enthusiast'
    },
    {
      id: 'user14',
      email: 'alex.wong@mit.edu',
      password: 'password123',
      name: 'Alex Wong',
      university: 'MIT',
      major: 'Mechanical Engineering',
      graduationYear: '2025',
      bio: 'Always looking for good food'
    },
    {
      id: 'user18',
      email: 'lisa.chen@bu.edu',
      password: 'password123',
      name: 'Lisa Chen',
      university: 'Boston University',
      major: 'Health Sciences',
      graduationYear: '2024',
      bio: 'Fitness and wellness focused'
    },
    {
      id: 'user23',
      email: 'marcus.brown@mit.edu',
      password: 'password123',
      name: 'Marcus Brown',
      university: 'MIT',
      major: 'Physics',
      graduationYear: '2025',
      bio: 'Soccer and futsal player'
    },
    {
      id: 'user29',
      email: 'sophie.park@bu.edu',
      password: 'password123',
      name: 'Sophie Park',
      university: 'Boston University',
      major: 'Korean Studies',
      graduationYear: '2024',
      bio: 'Korean language and culture'
    },
    {
      id: 'user32',
      email: 'james.wilson@harvard.edu',
      password: 'password123',
      name: 'James Wilson',
      university: 'Harvard University',
      major: 'International Relations',
      graduationYear: '2025',
      bio: 'Language exchange partner'
    },
    {
      id: 'user37',
      email: 'rachel.kim@northeastern.edu',
      password: 'password123',
      name: 'Rachel Kim',
      university: 'Northeastern University',
      major: 'Social Sciences',
      graduationYear: '2024',
      bio: 'Board game enthusiast'
    },
    {
      id: 'user44',
      email: 'tom.anderson@bu.edu',
      password: 'password123',
      name: 'Tom Anderson',
      university: 'Boston University',
      major: 'Environmental Science',
      graduationYear: '2025',
      bio: 'Outdoor activities lover'
    }
  ];

  let insertedCount = 0;

  users.forEach((user) => {
    // Hash the password
    bcrypt.hash(user.password, 10, (err, hashedPassword) => {
      if (err) {
        console.error(`Error hashing password for ${user.name}:`, err);
        return;
      }

      const sql = `
        INSERT INTO users (
          id, email, password_hash, name, university, major, graduation_year, bio
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `;

      db.run(sql, [
        user.id,
        user.email,
        hashedPassword,
        user.name,
        user.university,
        user.major,
        user.graduationYear,
        user.bio
      ], (err) => {
        if (err) {
          if (err.message.includes('UNIQUE constraint failed')) {
            console.log(`⚠️  User already exists: ${user.name} (${user.email})`);
          } else {
            console.error(`Error inserting user ${user.name}:`, err);
          }
        } else {
          console.log(`✓ Created user: ${user.name} (${user.email})`);
        }

        insertedCount++;
        if (insertedCount === users.length) {
          console.log(`\n✅ Successfully processed ${users.length} users!`);
          db.close(() => {
            console.log('Database connection closed.');
            process.exit(0);
          });
        }
      });
    });
  });
}
