(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\s]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^\d{1,2}((,)|(,25)|(,50)|(,5)|(,75)|(,0)|(,00))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re ",25") (str.to_re ",50") (str.to_re ",5") (str.to_re ",75") (str.to_re ",0") (str.to_re ",00"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
; ^[2-5](2|4|6|8|0)(A(A)?|B|C|D(D(D)?)?|E|F|G|H)$
(assert (not (str.in_re X (re.++ (re.range "2" "5") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8") (str.to_re "0")) (re.union (re.++ (str.to_re "A") (re.opt (str.to_re "A"))) (str.to_re "B") (str.to_re "C") (re.++ (str.to_re "D") (re.opt (re.++ (str.to_re "D") (re.opt (str.to_re "D"))))) (str.to_re "E") (str.to_re "F") (str.to_re "G") (str.to_re "H")) (str.to_re "\u{0a}")))))
; FTP.*www\x2Ewordiq\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "FTP") (re.* re.allchar) (str.to_re "www.wordiq.com\u{1b}\u{0a}")))))
(check-sat)
