:funs(
  ; (str.split s r A) is the array obtained by split s with the shortest and longest match of r in s.
  ; Note that if r is empty string, the result is array of char sequences of s. 
  (str.split String RegLan (Array Int String))

  ; (str.join A s t) is the string obtained by join the elements of A by s.
  ; Note that if A is empty array, the result is empty string
  (str.join (Array Int String) String String)
)