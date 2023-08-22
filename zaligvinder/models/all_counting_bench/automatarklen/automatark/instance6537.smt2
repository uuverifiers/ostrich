(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}rjs/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rjs/i\u{0a}"))))
; /\/\d+\.mp3\?rnd=\d+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re ".mp3?rnd=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; (^[1]$)|(^[1]+\d*\.+\d*[1-5]$)
(assert (str.in_re X (re.union (str.to_re "1") (re.++ (str.to_re "\u{0a}") (re.+ (str.to_re "1")) (re.* (re.range "0" "9")) (re.+ (str.to_re ".")) (re.* (re.range "0" "9")) (re.range "1" "5")))))
; ^[A-Za-z]{1}[0-9]{7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
