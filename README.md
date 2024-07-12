# emotional_social

The project was created and developed to meet the requirements specified in the case study. Requests like making a simple social media platform and allowing sharing on the platform have been fulfilled. firebase_auth package was used to store the user information. Additionally, the cloud_firestore package was used to store the detailed information of registered users. Users can register with their email account or easily login with their Google accounts. The cloud_firestore package was also used to store and retrieve posts
<br>

## License

This repository is licensed under the MIT License, allowing you to freely use, modify, and distribute the template as desired. If you use the site's design with minimal changes, please acknowledge me as the original designer.
<br>

## Screenshots
<br>

### Login Page
<img src="/screenshots/LoginPage.png" alt="Screenshot from App" width="300" />
A dark color scheme was used for the widgets on the login screen. Additionally, 3 emojis were used to reflect purpose of application. A Google image was used to indicate that users can login with Google Account. At the bottom of the screen, there is a Sign Up button in the form of Text.
<br><br>

### Register Page
<div style="display: flex; justify-content: space-between;">
  <img src="/screenshots/RegisterScreen-1.png" alt="Screenshot from App" width="300" />
  <img src="/screenshots/RegisterScreen-2.png" alt="Screenshot from App" width="300" />
  <img src="/screenshots/RegisterScreen-3.png" alt="Screenshot from App" width="300" />
</div>
A multi screen architecture was used on the registration page so that users can focus directly on the needed information. User will see the only required information on the current page. With that, a simple structure was established for the registration process.
<br><br>

### Home Page
<img src="/screenshots/HomeScreen.png" alt="Screenshot from App" width="300" />
There is a post sharing section at the top of home page. There is a TextField for users to write text and a section for selecting emojis. With that there is a button to share post. Below the post sharing section, the last 10 posts from the database are displayed. As you scroll down, 10 more posts load with the Infinite Scroll feature.
<br><br>

### Post Details Page
<img src="/screenshots/PostDetailScreen.png" alt="Screenshot from App" width="300" />
When tapping on a post on the home page, or on the “Read More” if the post content is long, it redirects to a page where the full text of the post can be viewed.
<br><br>