const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10
});

app.get('/health', (req, res) => {
  res.status(200).send('Backend is healthy');
});

app.get('/api/products', async (req, res) => {
  try {
    const [products] = await pool.query(
      'SELECT * FROM products ORDER BY id'
    );
    res.json(products);
  } catch (error) {
    console.error('Database query failed:', error);
    res.status(500).json({ error: 'Database query failed' });
  }
});

async function start() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS products (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      price DECIMAL(10,2) NOT NULL
    )
  `);

  const [rows] = await pool.query(
    'SELECT COUNT(*) AS total FROM products'
  );

  if (rows[0].total === 0) {
    await pool.query(`
      INSERT INTO products (name, price)
      VALUES
      ('Laptop', 55000),
      ('Mobile', 25000),
      ('Keyboard', 1500),
      ('Mouse', 800)
    `);
  }

  app.listen(3000, '127.0.0.1', () => {
    console.log('Backend running on port 3000');
  });
}

start().catch(error => {
  console.error('Backend startup failed:', error);
  process.exit(1);
});