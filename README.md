# NASA judge

This is an Online Judge for system and network administration. At the same time, the types of judging are not limited to system and network administration. Instead, profiles can be used to evaluate a variety of information subjects. Assignments, such as programming, compilation systems, computer organization, multi-parallel programming, etc.

## Run

1. Clone this repo

```bash
git clone https://github.com/NCKU-NASA/nasa-judge
cd nasa-judge
```

2. Write your judge script or clone `Demo-Judge-Script`

```bash
git clone https://github.com/NCKU-NASA/Demo-Judge-Script
```

3. Set your environment var `default.env` `db.env` `smtp.env`

4. Set your judge script location at `docker-compose.yml`

![image](https://github.com/user-attachments/assets/380f35ba-ad1d-4fbd-bd99-bfa3349f4985)

5. Run `docker compose up -d`

## Architecture

![image5](https://github.com/user-attachments/assets/972550f7-1052-4099-8469-521b4417d250)

![image1](https://github.com/user-attachments/assets/1e1317ae-06ab-4b83-933c-c33a71f7d4ab)
