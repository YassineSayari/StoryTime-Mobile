const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const User = require('../models/user');
passport.use(
  new GoogleStrategy(
    {
      clientID: "832896996125-fl4m2ulskhqj042j83ae3tt31tvl41ld.apps.googleusercontent.com",
      clientSecret: "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",
      callbackURL: 'http://localhost:3002/api/v1/users/auth/google/callback',
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        let existingUser = await User.findOne({ googleId: profile.id });
        if (existingUser) {
          return done(null, existingUser);
        }

        const newUser = new User({
          googleId: profile.id,
          fullName: profile.displayName,
          email: profile.emails[0].value,
          image: profile.photos[0].value,
          // Add other fields as necessary
        });

        await newUser.save();
        done(null, newUser);
      } catch (err) {
        done(err, false);
      }
    }
  )
);

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const user = await User.findById(id);
    done(null, user);
  } catch (err) {
    done(err, false);
  }
});
