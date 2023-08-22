(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (not (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}"))))
; ^([1-9]|(0|1|2)[0-9]|30)(/|-)([1-9]|1[0-2]|0[1-9])(/|-)(14[0-9]{2})$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (str.to_re "\u{0a}14") ((_ re.loop 2 2) (re.range "0" "9")))))
; \[(.+)\].+\[n?varchar\].+NULL,
(assert (not (str.in_re X (re.++ (str.to_re "[") (re.+ re.allchar) (str.to_re "]") (re.+ re.allchar) (str.to_re "[") (re.opt (str.to_re "n")) (str.to_re "varchar]") (re.+ re.allchar) (str.to_re "NULL,\u{0a}")))))
; ^(^(100{1,1}$)|^(100{1,1}\.[0]+?$))|(^([0]*\d{0,2}$)|^([0]*\d{0,2}\.(([0][1-9]{1,1}[0]*)|([1-9]{1,1}[0]*)|([0]*)|([1-9]{1,2}[0]*)))$)$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.* (str.to_re "0")) (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.* (str.to_re "0")))))) (str.to_re "\u{0a}")) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0")) (str.to_re ".") (re.+ (str.to_re "0")))))))
(assert (> (str.len X) 10))
(check-sat)
