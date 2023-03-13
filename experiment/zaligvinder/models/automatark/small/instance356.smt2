(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\-]{0,1}[0-9]{1,}(([\.\,]{0,1}[0-9]{1,})|([0-9]{0,}))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (re.union (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) (re.+ (re.range "0" "9"))) (re.* (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^([0][1-9]|[1][0-2]):[0-5][0-9] {1}(AM|PM|am|pm)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") ((_ re.loop 1 1) (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "am") (str.to_re "pm")) (str.to_re "\u{0a}"))))
; /stat2\.php\?w=\d+\u{26}i=[0-9a-f]{32}\u{26}a=\d+/Ui
(assert (str.in_re X (re.++ (str.to_re "/stat2.php?w=") (re.+ (re.range "0" "9")) (str.to_re "&i=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "&a=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(check-sat)
