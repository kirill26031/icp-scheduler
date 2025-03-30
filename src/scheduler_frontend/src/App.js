import { scheduler_backend } from 'declarations/scheduler_backend';

class App {

  eventsOfMonth = new Map();
  currentYear;
  currentMonth;

  displayEventsAt = async function(year, month, day){
        if(year !== currentYear || month !== currentMonth){
            await loadEvents(year, month)
        }
        const eventsContainer = document.querySelector('.events-container')
        eventsContainer.innerHTML=""
        const events = eventsOfMonth.get(day)
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
        fetch('/api/events/by-month/'+year+'/'+month)
        .then(res => res.json())
        .then(r => {
            currentMonth = month
            currentYear = year
            eventsOfMonth.clear()
            r.data.forEach(event => {
                let datetime = new Date(event.nextEventDate)
                let updatedList = eventsOfMonth.get(datetime.getDate())
                if(updatedList == null) updatedList = []
                updatedList.push({
                    name : event.eventName,
                    description : event.eventDescription,
                    time : datetime
                })
                eventsOfMonth.set(datetime.getDate(), updatedList)
            })
            for(let i=1; i<32; i = parseInt(parseInt(i)+parseInt(1))){
                document.querySelector('.day-'+i).className =
                    eventsOfMonth.has(i) ?
                        document.querySelector('.day-'+i).className += " has-events" :
                    document.querySelector('.day-'+i).className.replace('has-events', '')
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

    constructor() {
      document.querySelector('#logout').addEventListener('click', this.logout);
    }
}

export default App;
