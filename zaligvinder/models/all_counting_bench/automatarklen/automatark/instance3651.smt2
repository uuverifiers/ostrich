(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{1}$|^[1-6]{1}[0-3]{1}$|^64$|\-[1-9]{1}$|^\-[1-6]{1}[0-3]{1}$|^\-64$
(assert (not (str.in_re X (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "64") (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "-64\u{0a}")))))
; ^[1-9]{1}[0-9]{3}-(0[1-9]{1}|1[0-2]{1})-([0-2]{1}[1-9]{1}|3[0-1]{1}) ([0-1]{1}[0-9]{1}|2[0-3]{1}):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "2")))) (str.to_re "-") (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "3") ((_ re.loop 1 1) (re.range "0" "1")))) (str.to_re " ") (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}mp4/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mp4/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
