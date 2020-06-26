class Today{
  DateTime today = DateTime.now();
}

bool compareTheDates(int dateOfEvent, int dateToCompare){
  dateOfEvent = dateOfEvent-1;
  for(int i= 128; i>=2; i= (i~/2)) {
    dateOfEvent -= i;
    if (dateOfEvent < 0) {
      dateOfEvent += i;
    }else {
      if(i == 128){
        if(dateToCompare == 7){
          return true;
        }
      }else if(i==64){
        if(dateToCompare == 6){
          return true;
        }
      }else if(i==32){
        if(dateToCompare == 5){
          return true;
        }
      }else if(i==16){
        if(dateToCompare == 4){
          return true;
        }
      }else if(i==8){
        if(dateToCompare == 3){
          return true;
        }
      }else if(i==4){
        if(dateToCompare == 2){
          return true;
        }
      }else if(i==2){
        if(dateToCompare == 1){
          return true;
        }
      }
    }
  }
  return false;
}

bool isItToday(int dateOfEvent){
  DateTime today = DateTime.now();
  dateOfEvent = dateOfEvent-1;
  for(int i= 128; i>=2; i= (i~/2)) {
    dateOfEvent -= i;
    if (dateOfEvent < 0) {
      dateOfEvent += i;
    }else {
      if(i == 128){
        if(today.weekday == 7){
          return true;
        }
      }else if(i==64){
        if(today.weekday == 6){
          return true;
        }
      }else if(i==32){
        if(today.weekday == 5){
          return true;
        }
      }else if(i==16){
        if(today.weekday == 4){
          return true;
        }
      }else if(i==8){
        if(today.weekday == 3){
          return true;
        }
      }else if(i==4){
        if(today.weekday == 2){
          return true;
        }
      }else if(i==2){
        if(today.weekday == 1){
          return true;
        }
      }
    }
  }
  return false;
}