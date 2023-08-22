(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3A\w+Minutes\d+www\x2Eeblocs\x2EcomHost\x3ARunnerHost\u{3a}\x2Ehtmldll\x3F
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Minutes") (re.+ (re.range "0" "9")) (str.to_re "www.eblocs.com\u{1b}Host:RunnerHost:.htmldll?\u{0a}"))))
; ^([0][1-9]|[1][0-2]):[0-5][0-9] {1}(AM|PM|am|pm)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") ((_ re.loop 1 1) (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "am") (str.to_re "pm")) (str.to_re "\u{0a}")))))
; [0](\d{9})|([0](\d{2})( |-|)((\d{3}))( |-|)(\d{4}))|[0](\d{2})( |-|)(\d{7})|(\+|00|09)(\d{2}|\d{3})( |-|)(\d{2})( |-|)((\d{3}))( |-|)(\d{4})
(assert (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (re.union (str.to_re "+") (str.to_re "00") (str.to_re "09")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
