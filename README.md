# Infinity for Reddit Docker Build

This workspace contains the necessary files to build the Infinity for Reddit Android app locally using Docker.

## Setup

<!-- 1. Copy [`.env.example`](command:_github.copilot.openRelativePath?%5B%22.env.example%22%5D ".env.example") to [`.env`](command:_github.copilot.openRelativePath?%5B%22.env%22%5D ".env") and replace `your_api_token` and `your_reddit_username` with your Reddit API token and Reddit username respectively.

    ```bash
    cp .env.example .env
    ```

2. Build and run the Docker container using Docker Compose.

    ```bash
    docker-compose up
    ``` -->

1. Create a API application [here](https://www.reddit.com/prefs/apps) with the following settings:
    - Name: `{YourRedditUsername}s-app`
    - Type: `installed app`
    - Redirect URI: `http://127.0.0.1`

2. Clone this repository and copy the `.env.example` file to `.env`.

    ```bash
    git clone
    cd Infinity-For-Reddit-Builder
    cp .env.example .env
    ```

3. Replace `your_api_token` and `your_reddit_username` in the `.env` file with the API token and your Reddit username respectively.

4. Build and run the Docker container using Docker Compose.

    ```bash
    docker-compose up
    ```

5. After the build is complete, copy the built APK to your host machine.

    ```bash
    docker cp infinity-build:/Infinity.apk .
    ```

6. Install the APK on your Android device.

Note: The first build will take some time because gradle will download all the dependencies. The subsequent builds will be faster.

## New Update?

To rebuild the APK the next time simply run the following command to build the APK and then copy it to your host machine.

`Warning: This only works if you still have the container, if not, you will have to rebuild the container again`

```bash
docker start infinity-build
...
docker cp infinity-build:/Infinity.apk .
```

## Dockerfile

The Dockerfile uses the Azul Zulu OpenJDK 11 image as the base image, installs the required dependencies, and sets up the Android SDK.

## Entrypoint Script

The [`entrypoint.sh`](command:_github.copilot.openRelativePath?%5B%22entrypoint.sh%22%5D "entrypoint.sh") script fetches the source code, injects your Reddit API token and Reddit username into the source code, and also uses @TanukiAI's keystore to sign the APK.

## Credits

- [u/HostileEnemy](https://github.com/Docile-Alligator) for making the Infinity for Reddit app.
- [u/AllMFHH](https://www.reddit.com/user/AllMFHH/) for the colab notebook which I used to build this Dockerfile.
- Original post by u/AllMFHH about the colab notebook: [Reddit Post](https://www.reddit.com/r/Infinity_For_Reddit/comments/14c2v5x/)
- [TanukiAI](https://github.com/TanukiAI) for the keystore used to sign the APK.
- [Azul Systems](https://www.azul.com/) for the Azul Zulu OpenJDK 11 image.