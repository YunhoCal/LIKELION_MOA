const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, 'moa.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Database connection failed:', err);
    process.exit(1);
  } else {
    console.log('Database connected at', dbPath);
    seedDatabase();
  }
});

function seedDatabase() {
  const activities = [
    // Study Activities
    {
      id: '1',
      title: 'CS330 Algorithms Study',
      category: 'Study',
      description: 'Midterm preparation for data structures',
      hostUserId: 'user1',
      hostName: 'John Doe',
      hostUniversity: 'Boston University',
      locationName: 'BU Library - 3rd Floor',
      locationLat: 42.3505,
      locationLng: -71.1054,
      startDateTime: new Date(Date.now() + 3600 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 7200 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 6,
      currentParticipants: 3,
      status: 'open',
      participants: JSON.stringify(['user1', 'user2', 'user3'])
    },
    {
      id: '10',
      title: 'GRE Quant Practice',
      category: 'Study',
      description: 'Quantitative reasoning prep',
      hostUserId: 'user5',
      hostName: 'Sarah Kim',
      hostUniversity: 'Northeastern University',
      locationName: 'Northeastern Library',
      locationLat: 42.3390,
      locationLng: -71.0890,
      startDateTime: new Date(Date.now() + 7200 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 10800 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 5,
      currentParticipants: 4,
      status: 'open',
      participants: JSON.stringify(['user5', 'user6', 'user7', 'user8'])
    },
    {
      id: '11',
      title: 'TOEFL Speaking Group',
      category: 'Study',
      description: 'English speaking practice for TOEFL',
      hostUserId: 'user9',
      hostName: 'Emily Park',
      hostUniversity: 'MIT',
      locationName: 'MIT Stata Center',
      locationLat: 42.3600,
      locationLng: -71.0927,
      startDateTime: new Date(Date.now() + 10800 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 14400 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 8,
      currentParticipants: 6,
      status: 'open',
      participants: JSON.stringify(['user9', 'user10', 'user1', 'user2', 'user3', 'user4'])
    },
    // Meal Buddy Activities
    {
      id: '2',
      title: 'Korean Lunch',
      category: 'Meal Buddy',
      description: 'Let\'s eat Korean BBQ together',
      hostUserId: 'user2',
      hostName: 'Jane Smith',
      hostUniversity: 'Boston University',
      locationName: 'Allston (Korea Town)',
      locationLat: 42.3506,
      locationLng: -71.1064,
      startDateTime: new Date(Date.now() + 1800 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 5400 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 4,
      currentParticipants: 2,
      status: 'open',
      participants: JSON.stringify(['user2', 'user4'])
    },
    {
      id: '12',
      title: 'Dinner at Harvard Square',
      category: 'Meal Buddy',
      description: 'Korean restaurant dinner',
      hostUserId: 'user11',
      hostName: 'David Lee',
      hostUniversity: 'Harvard University',
      locationName: 'Harvard Square',
      locationLat: 42.3735,
      locationLng: -71.1207,
      startDateTime: new Date(Date.now() + 54000 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 57600 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 5,
      currentParticipants: 3,
      status: 'open',
      participants: JSON.stringify(['user11', 'user12', 'user13'])
    },
    {
      id: '13',
      title: 'Lunch Near MIT',
      category: 'Meal Buddy',
      description: 'Casual lunch, trying new place',
      hostUserId: 'user14',
      hostName: 'Alex Wong',
      hostUniversity: 'MIT',
      locationName: 'Kendall Square',
      locationLat: 42.3627,
      locationLng: -71.0894,
      startDateTime: new Date(Date.now() + 43200 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 46800 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 6,
      currentParticipants: 4,
      status: 'open',
      participants: JSON.stringify(['user14', 'user15', 'user16', 'user17'])
    },
    // Sports Activities
    {
      id: '3',
      title: 'Basketball Game',
      category: 'Sports',
      description: '5v5 casual basketball',
      hostUserId: 'user3',
      hostName: 'Mike Johnson',
      hostUniversity: 'Boston University',
      locationName: 'BU FitRec',
      locationLat: 42.3510,
      locationLng: -71.1070,
      startDateTime: new Date(Date.now() + 21600 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 25200 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 10,
      currentParticipants: 8,
      status: 'full',
      participants: JSON.stringify(['user3', 'user1', 'user2', 'user4', 'user5', 'user6', 'user7', 'user8'])
    },
    {
      id: '14',
      title: 'Jogging at Charles River',
      category: 'Sports',
      description: 'Morning jog along the river',
      hostUserId: 'user18',
      hostName: 'Lisa Chen',
      hostUniversity: 'Boston University',
      locationName: 'Charles River Esplanade',
      locationLat: 42.3598,
      locationLng: -71.1093,
      startDateTime: new Date(Date.now() + 28800 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 32400 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 12,
      currentParticipants: 5,
      status: 'open',
      participants: JSON.stringify(['user18', 'user19', 'user20', 'user21', 'user22'])
    },
    {
      id: '15',
      title: 'Futsal Game at MIT',
      category: 'Sports',
      description: 'Indoor soccer, beginner friendly',
      hostUserId: 'user23',
      hostName: 'Marcus Brown',
      hostUniversity: 'MIT',
      locationName: 'MIT Gym',
      locationLat: 42.3611,
      locationLng: -71.0896,
      startDateTime: new Date(Date.now() + 57600 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 61200 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 8,
      currentParticipants: 6,
      status: 'open',
      participants: JSON.stringify(['user23', 'user24', 'user25', 'user26', 'user27', 'user28'])
    },
    // Others/Community Activities
    {
      id: '4',
      title: 'Coffee Chat in Korean',
      category: 'Others',
      description: 'Casual conversation in Korean',
      hostUserId: 'user29',
      hostName: 'Sophie Park',
      hostUniversity: 'Boston University',
      locationName: 'Café near BU',
      locationLat: 42.3485,
      locationLng: -71.1035,
      startDateTime: new Date(Date.now() + 14400 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 18000 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 6,
      currentParticipants: 3,
      status: 'open',
      participants: JSON.stringify(['user29', 'user30', 'user31'])
    },
    {
      id: '16',
      title: 'Language Exchange - Korean & English',
      category: 'Others',
      description: 'Practice both Korean and English',
      hostUserId: 'user32',
      hostName: 'James Wilson',
      hostUniversity: 'Harvard University',
      locationName: 'Harvard Square Café',
      locationLat: 42.3735,
      locationLng: -71.1207,
      startDateTime: new Date(Date.now() + 50400 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 54000 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 8,
      currentParticipants: 5,
      status: 'open',
      participants: JSON.stringify(['user32', 'user33', 'user34', 'user35', 'user36'])
    },
    {
      id: '17',
      title: 'Board Game Night',
      category: 'Others',
      description: 'Play board games, free snacks!',
      hostUserId: 'user37',
      hostName: 'Rachel Kim',
      hostUniversity: 'Northeastern University',
      locationName: 'NEU Student Center',
      locationLat: 42.3390,
      locationLng: -71.0890,
      startDateTime: new Date(Date.now() + 64800 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 72000 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 12,
      currentParticipants: 7,
      status: 'open',
      participants: JSON.stringify(['user37', 'user38', 'user39', 'user40', 'user41', 'user42', 'user43'])
    },
    {
      id: '18',
      title: 'Walk Along Charles River',
      category: 'Others',
      description: 'Leisurely walk and chat',
      hostUserId: 'user44',
      hostName: 'Tom Anderson',
      hostUniversity: 'Boston University',
      locationName: 'Charles River Park',
      locationLat: 42.3598,
      locationLng: -71.1093,
      startDateTime: new Date(Date.now() + 36000 * 1000).toISOString(),
      endDateTime: new Date(Date.now() + 39600 * 1000).toISOString(),
      isInstant: 0,
      maxParticipants: 10,
      currentParticipants: 4,
      status: 'open',
      participants: JSON.stringify(['user44', 'user45', 'user46', 'user47'])
    }
  ];

  // Insert activities one by one
  let insertedCount = 0;
  activities.forEach((activity) => {
    const sql = `
      INSERT INTO activities (
        id, title, category, description, host_user_id, host_name, host_university,
        location_name, location_lat, location_lng, start_date_time, end_date_time,
        is_instant, max_participants, current_participants, status, participants
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.run(sql, [
      activity.id,
      activity.title,
      activity.category,
      activity.description,
      activity.hostUserId,
      activity.hostName,
      activity.hostUniversity,
      activity.locationName,
      activity.locationLat,
      activity.locationLng,
      activity.startDateTime,
      activity.endDateTime,
      activity.isInstant,
      activity.maxParticipants,
      activity.currentParticipants,
      activity.status,
      activity.participants
    ], (err) => {
      if (err) {
        console.error(`Error inserting activity ${activity.id}:`, err);
      } else {
        insertedCount++;
        console.log(`✓ Inserted activity: ${activity.title}`);
      }

      if (insertedCount === activities.length) {
        console.log(`\n✅ Successfully inserted ${insertedCount} activities into the database!`);
        db.close(() => {
          console.log('Database connection closed.');
          process.exit(0);
        });
      }
    });
  });
}
