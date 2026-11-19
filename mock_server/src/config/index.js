const config = {
  port: process.env.PORT || 3000,
  delays: {
    normal: 0,
    slow: 3000,
    timeout: 30000,
  },
  officeLocation: {
    latitude: 10.0303,
    longitude: 76.3358,
    radiusMeters: 200,
  },
};

module.exports = config;
