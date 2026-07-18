# Campus AI Hub 🎓🤖

An AI-powered application designed to make campus life easier for students. By integrating Generative AI and LLMs, this platform helps answer student queries, provides academic assistance, and keeps campus resources in one easy-to-access place. 

We built this project during a hackathon to solve real problems students face when trying to find campus information quickly.

## ✨ Features

* **AI Student Assistant:** Uses LLMs to answer questions about academics, schedules, and campus facilities in real-time.
* **Central Hub:** A single dashboard to access important campus tools and links.
* **Secure Login:** JWT-based authentication keeps student sessions and data secure.
* **Simple Interface:** Clean and responsive UI that works well on both phones and laptops.

## 🛠️ Tech Stack

This project was built using the MERN stack along with AI integrations:
* **Frontend:** React.js
* **Backend:** Node.js, Express.js
* **Database:** MongoDB
* **AI:** Generative AI / LLM APIs

## 🚀 Running the Project Locally

Follow these steps to get the app running on your own machine.

**1. Clone the repository:**

    git clone https://github.com/CodifyWithShravan/Campus-AI-Hub.git
    cd Campus-AI-Hub

***2. Backend Server Setup (Python):**
Open a terminal, navigate to your server directory, set up a virtual environment, and install the dependencies.

    cd server   (or whatever your backend folder is named)
    python -m venv venv

Activate the virtual environment:
* On Windows: `venv\Scripts\activate`
* On Mac/Linux: `source venv/bin/activate`

Install the required Python packages:

    pip install -r requirements.txt

Create a .env file in this backend folder and add your environment variables:

    MONGO_URI=your_mongodb_connection_string
    JWT_SECRET=your_jwt_secret
    AI_API_KEY=your_llm_api_key_here

Start the Python backend server:

    python app.py   (or flask run / uvicorn main:app --reload depending on your framework)

**3. Frontend Client Setup:**
Open a **new** terminal window, navigate to your client directory, install dependencies, and start the React app.

    cd client   (or whatever your frontend folder is named)
    npm install
    npm start   (or npm run dev if using Vite)

## 🤝 Contributors / Team

This was a collaborative hackathon effort! Huge thanks to everyone who worked on bringing this platform to life.

* **Shravan** - *Full Stack Developer* - [GitHub](https://github.com/CodifyWithShravan)
* **Vooka Kavya Suma** - *Frontend Developer* - [GitHub](https://github.com/VookaKavyaSuma)*

## 💡 Contributing

If you want to suggest improvements or fix bugs, feel free to open an issue or submit a pull request on the [issues page](https://github.com/CodifyWithShravan/Campus-AI-Hub/issues).