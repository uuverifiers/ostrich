(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /hwid=[^\u{0a}\u{26}]+?\u{26}pc=[^\u{0a}\u{26}]+?\u{26}localip=[^\u{0a}\u{26}]+?\u{26}winver=/U
(assert (not (str.in_re X (re.++ (str.to_re "/hwid=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&pc=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&localip=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&winver=/U\u{0a}")))))
; ^((\-|d|l|p|s){1}(\-|r|w|x){9})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "d") (str.to_re "l") (str.to_re "p") (str.to_re "s"))) ((_ re.loop 9 9) (re.union (str.to_re "-") (str.to_re "r") (str.to_re "w") (str.to_re "x")))))))
; ^(\+)?([9]{1}[2]{1})?-? ?(\()?([0]{1})?[1-9]{2,4}(\))?-? ??(\()?[1-9]{4,7}(\))?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (str.to_re "2")))) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 2 4) (re.range "1" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 4 7) (re.range "1" "9")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}"))))
; MyverToolbarTrojanControlHost\x3A
(assert (str.in_re X (str.to_re "MyverToolbarTrojanControlHost:\u{0a}")))
(check-sat)
