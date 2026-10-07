# OptiSked AI — Program-Isolated Scheduling Update

This build updates the Schedule Builder so Program Heads can:

- select a teacher from registered accounts whose role is **Teacher**;
- no longer enter a teacher username manually;
- choose a teaching duration of **1, 1.5, 2, 2.5, 3, 3.5, or 4 hours**;
- select a start time and have the end time calculated automatically;
- keep the selected duration when using an AI **Apply Fix** suggestion;
- continue using conflict detection for teacher, room, section, availability, and approved leave;
- save the schedule with the selected Teacher account's canonical name and username internally.

The supplied OptiSked AI logo is included at `static/optisked-logo.jpg`.

## Run locally

```bash
python -m venv .venv
.venv\\Scripts\\activate
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000`.

There are no demo accounts or demo schedules in this build.


UI update: larger, more readable text throughout the web interface. The logo remains the real static/optisked-logo.jpg asset.


## Program Head data separation

When a user signs up as **Program Head**, the system requires them to select the academic program they manage. The Program Head Schedule Builder and Code Generation pages only display records for that assigned program. Program Heads cannot create, delete, or modify schedules belonging to another program.

Conflict detection remains global: when a Program Head creates a schedule, OptiSked checks the complete schedule database for cross-program conflicts such as a shared teacher or double-booked room, while section conflicts remain scoped to the same program/year/section.

Existing Program Head accounts created before this update are sent to a one-time **Program Head Setup** page after login so their managed program can be assigned.


### Readability Update
The current UI uses larger typography and spacing for easier classroom and panel demonstration. The official uploaded logo is located at `static/optisked-logo.jpg`.

## Attendance and year-level workflow

- Program Head schedules, code generation, attendance records, and student class records are filtered to the Program Head's assigned program.
- Teacher leave requests are tied to the specific class/program. Only the Program Head responsible for that class program can approve or reject the request.
- Teacher class status shows **Pending**, **Attending**, **Leave Pending**, or **On Leave** for the current day.
- Teacher attendance requires an attached image proof. The server rejects attendance submissions without an image file.
- Teacher class cards show enrolled students under the class's year level, with editable **Present**, **Absent**, and **Excused** attendance controls.
- Student schedules show their faculty status as **Attending**, **On Leave**, **Leave Pending**, or **Pending**.
- Program Head Attendance Records show today's class-by-class teacher status organized by year level, plus photo proof and program-scoped leave requests.
- Global conflict checking remains active across all programs, including cross-program teacher and room conflicts.

## Machine Learning Recommendation Model

OptiSked AI uses a hybrid recommendation approach:

1. The rule-based constraint engine removes candidates with teacher, room, section, preferred-day, availability, or approved-leave conflicts.
2. The ML layer uses a **Scikit-learn Random Forest Classifier** to rank the remaining candidates based on historical scheduling patterns.
3. Published schedules are treated as positive historical examples; nearby alternative slots that were not historically used are generated as negative examples.
4. New recommendations are ranked by ML suitability and can be applied through **Apply Fix**.
5. The model is retrained from the current published-schedule dataset whenever recommendations are generated, so newly verified schedules become part of future training data.

If there is not enough history or Scikit-learn is temporarily unavailable, the deterministic constraint engine still protects schedule validity and the UI reports that ML ranking is inactive.
