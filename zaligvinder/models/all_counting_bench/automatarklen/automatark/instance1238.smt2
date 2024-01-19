(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2,6}-\d{2}-\d$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
; ^(\+{1,2}?([0-9]{2,4}|\([0-9]{2,4}\))?(-|\s)?)?[0-9]{2,3}(-|\s)?[0-9\-]{5,10}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 2) (str.to_re "+")) (re.opt (re.union ((_ re.loop 2 4) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ")")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 10) (re.union (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (not (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}"))))
; Host\x3A\dMicrosoft\w+\+Version\+
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Microsoft") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "+Version+\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
