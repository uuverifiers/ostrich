(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1..9])|(0[1..9])|(1\d)|(2\d)|(3[0..1])).((\d)|(0\d)|(1[0..2])).(\d{4})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ".") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "1"))) (str.to_re "1") (str.to_re ".") (str.to_re "9")) re.allchar (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "2")))) re.allchar ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /(sIda\/sId|urua\/uru)[abcd]\.classPK/ims
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "sIda/sId") (str.to_re "urua/uru")) (re.union (str.to_re "a") (str.to_re "b") (str.to_re "c") (str.to_re "d")) (str.to_re ".classPK/ims\u{0a}"))))
; IP-[^\n\r]*URL\d\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPalToolbar
(assert (str.in_re X (re.++ (str.to_re "IP-") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "URL") (re.range "0" "9") (str.to_re "|roogoo|.cfgmPOPrtCUSTOMPalToolbar\u{0a}"))))
(check-sat)
