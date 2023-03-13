(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((([1]\d{2})|(22[0-3])|([1-9]\d)|(2[01]\d)|[1-9]).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "22") (re.range "0" "3")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.range "1" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9"))))))
; e2give\.comADRemoteHost\x3A
(assert (str.in_re X (str.to_re "e2give.comADRemoteHost:\u{0a}")))
; /filename=[^\n]*\u{2e}wmx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmx/i\u{0a}"))))
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
; DaysLOGHost\u{3a}Host\u{3a}\x7D\x7BOS\x3AHost\x3A
(assert (str.in_re X (str.to_re "DaysLOGHost:Host:}{OS:Host:\u{0a}")))
(check-sat)
