

class AppStringCustomMethods {
  static String getSiglasName(String name) {

    final List arrayLetters = name.trim().split('').toList();
    
    final List arrayLettersSecond = name.trim().split(' ').toList().length <= 1 ? ['',''] :  name.trim().split(' ').toList();
  
    final arraySecondWord =  arrayLettersSecond.length <= 1 ? [''] : arrayLettersSecond[1].split('').toList();
    
    final String fisrtLetter = arrayLetters.isEmpty? '' :arrayLetters[0];
    final String secondLetter = arraySecondWord.isEmpty ? '' :arraySecondWord[0];
  
    return (fisrtLetter.toUpperCase() + secondLetter.toUpperCase());

  }
}
