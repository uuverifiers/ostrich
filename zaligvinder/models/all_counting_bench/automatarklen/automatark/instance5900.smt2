(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+rprpgbnrppb\u{2f}ci[^\n\r]*RXFilteredDmInf\x5E
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "rprpgbnrppb/ci") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "RXFilteredDmInf^\u{0a}"))))
; /(action|setup)=[a-z]{1,4}/Ri
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "action") (str.to_re "setup")) (str.to_re "=") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/Ri\u{0a}")))))
; ^[1-9]{1}[0-9]{3}-(0[1-9]{1}|1[0-2]{1})-([0-2]{1}[1-9]{1}|3[0-1]{1}) ([0-1]{1}[0-9]{1}|2[0-3]{1}):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "2")))) (str.to_re "-") (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "3") ((_ re.loop 1 1) (re.range "0" "1")))) (str.to_re " ") (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Logger\w+gdvsotuqwsg\u{2f}dxt\.hd\dovpl\dHOST\x3AUser-Agent\x3AURLUBAgent%3fSchwindlerurl=Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "gdvsotuqwsg/dxt.hd") (re.range "0" "9") (str.to_re "ovpl") (re.range "0" "9") (str.to_re "HOST:User-Agent:URLUBAgent%3fSchwindlerurl=Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
