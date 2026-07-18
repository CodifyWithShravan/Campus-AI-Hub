# Campus AI Hub 🎓🤖

![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

An AI-powered application designed to make campus life easier for students. By integrating Generative AI and Large Language Models (LLMs), this platform helps answer student queries, provides academic assistance, and keeps campus resources in one easy-to-access place.

*Built to solve real problems students face when trying to find campus information quickly.*

---

## 📸 Screenshots

| AI Student Assistant | Central Dashboard |
| :---: | :---: |
| <img src="https://via.placeholder.com/400x250?text=AI+Chat+Interface" alt="AI Chat Interface" width="400"/> | <img src="https://via.placeholder.com/400x250?text=Campus+Dashboard" alt="Campus Dashboard" width="400"/> |

---

## ✨ Key Features

* **AI Student Assistant:** Uses LLMs to answer questions about academics, schedules, and campus facilities in real-time.
* **Central Hub:** A single dashboard to access important campus tools and links.
* **Secure Login:** Supabase authentication keeps student sessions and data strictly secure.
* **Simple Interface:** Clean, responsive UI that works flawlessly on both mobile and desktop screens.

---

## 🛠️ Tech Stack

* **Frontend:** React.js (Vite)
* **Backend:** Python (FastAPI)
* **Database & Auth:** Supabase
* **AI:** Generative AI (Google Gemini / Groq APIs)

---

## 🚀 Running the Project Locally

Follow these steps to get the development environment running on your machine.

### 1. Clone the Repository

    git clone https://github.com/CodifyWithShravan/Campus-AI-Hub.git
    cd Campus-AI-Hub

### 2. Backend Server Setup (Python)
Open a terminal, navigate to your server directory, set up a virtual environment, and install the dependencies.

    cd backend
    python -m venv .venv

**Activate the virtual environment:**
* On Windows (PowerShell): `.\.venv\Scripts\activate`
* On Mac/Linux: `source .venv/bin/activate`

**Install packages:**

    pip install -r requirements.txt

**Configure Environment Variables:**
Create a `.env` file in the backend folder (or copy the example file using `cp .env.example .env`) and add your specific keys:

    # Supabase Configuration
    SUPABASE_URL=your_supabase_project_url
    SUPABASE_KEY=your_supabase_anon_key

    # AI Model APIs
    GOOGLE_API_KEY=your_google_api_key
    GROQ_API_KEY=your_groq_api_key

**Start the Server:**

    uvicorn main:app --reload

### 3. Frontend Client Setup (React/Vite)
Open a **new** terminal window, navigate to your frontend directory, and install dependencies.

    cd frontend
    npm install

**Configure Environment Variables:**
Create a `.env` file in the root of the `frontend` folder and add your Supabase connection details:

    VITE_SUPABASE_URL=your_supabase_project_url
    VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

**Start the React App:**

    npm run dev

---

## 🤝 Contributors

This project was a collaborative hackathon effort! Huge thanks to the team for bringing this platform to life.

* **Shravan Kumar Thudi** - *Backend Developer* - [GitHub](https://github.com/CodifyWithShravan)
* **Vooka Kavya Suma** - *Frontend Developer* - [GitHub](https://github.com/VookaKavyaSuma)

---

## 💡 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check the [issues page](https://github.com/CodifyWithShravan/Campus-AI-Hub/issues) if you want to contribute to the project.