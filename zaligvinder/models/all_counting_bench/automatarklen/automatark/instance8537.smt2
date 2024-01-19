(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; RequestWindowszzzvmkituktgr\u{2f}etieencoder
(assert (not (str.in_re X (str.to_re "RequestWindowszzzvmkituktgr/etieencoder\u{0a}"))))
; ^(((0[0-9])|(1[0-9])|(2[0-3])):[0-5][0-9])$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))))
; e2give\.comADRemoteHost\x3A
(assert (str.in_re X (str.to_re "e2give.comADRemoteHost:\u{0a}")))
; /filename=[^\n]*\u{2e}f4p/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4p/i\u{0a}"))))
; ^([A-Z]{2}[9]{3}|[A-Z]{3}[9]{2}|[A-Z]{4}[9]{1}|[A-Z]{5})[0-9]{6}([A-Z]{1}[9]{1}|[A-Z]{2})[A-Z0,9]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (str.to_re "9"))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 2 2) (str.to_re "9"))) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 5 5) (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re "0") (str.to_re ",") (str.to_re "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
