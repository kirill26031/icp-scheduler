import { scheduler_backend } from 'declarations/scheduler_backend';

class App {

  constructor() {
    this.eventsOfMonth = new Map();
    this.currentYear = 2025;
    this.currentMonth = 3;

    document.querySelector('#logout').addEventListener('click', this.logout);
  }

  displayEventsAt = async function(year, month, day){
        if(year !== this.currentYear || month !== this.currentMonth){
            await loadEvents(year, month)
        }
        const eventsContainer = document.querySelector('.events-container')
        eventsContainer.innerHTML=""
        const events = this.eventsOfMonth.get(day)
        if(events !== undefined){
            events.sort((a, b)=>{
                return parseInt(a.time.getTime()) - parseInt(b.time.getTime())
            })
            events.forEach(event => {
                eventsContainer.append(displayEvent(event))
            })
        }

    };

    loadEvents = async function (year, month){
        const eventsContainer = document.querySelector('.events-container')
        eventsContainer.innerHTML=""
        
        scheduler_backend.getAllEventsInRange(year, month)
        .then(r => {
            this.currentMonth = month
            this.currentYear = year
            this.eventsOfMonth.clear()
            r.forEach(event => {
                console.log(event)
                let datetime = new Date(Number(event.startEventDate) / 1_000_000)
                let updatedList = this.eventsOfMonth.get(datetime.getDate())
                if(updatedList == null) updatedList = []
                updatedList.push({
                    name : event.eventName,
                    description : event.eventDescription,
                    time : datetime
                })
                this.eventsOfMonth.set(datetime.getDate(), updatedList)
                console.log(updatedList)
            })
            for(let i=1; i<32; i = parseInt(parseInt(i)+parseInt(1))){
                let dayElem = document.querySelector('.day-'+i)
                if (!dayElem) {
                    console.error("Day element is absent " + i)
                    continue
                }
                dayElem.className =
                this.eventsOfMonth.has(i) ?
                    dayElem.className += " has-events" :
                    dayElem.className.replace('has-events', '')
            }
        })
    }

    displayEvent = function(event){
        let rootEl = document.createElement("DIV")
        rootEl.className = "event-item-root"
        const name = document.createElement("P")
        name.innerText = event.name
        const eventDescription = document.createElement("P")
        eventDescription.innerText  = event.description
        const time = document.createElement("P")
        time.innerText = event.time.getHours()+":"+event.time.getMinutes()
        rootEl.insertBefore(name, null)
        rootEl.insertBefore(eventDescription, name)
        rootEl.insertBefore(time, eventDescription)
        return rootEl
    }

    serDayClass = function(day){
        return 'day-'+day
    }

    logout = function(){
      sessionStorage.removeItem('token')
      document.cookie+=";max-age=0"
      window.location='/'
    }
}

export default App;
