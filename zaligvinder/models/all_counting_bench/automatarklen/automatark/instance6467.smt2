(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9][.][0-9]{3}$
(assert (str.in_re X (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(([0-2]\d|[3][0-1])\/([0]\d|[1][0-2])\/[2][0]\d{2})$|^(([0-2]\d|[3][0-1])\/([0]\d|[1][0-2])\/[2][0]\d{2}\s00\:00\:00)$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/20") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/20") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "00:00:00"))))))
; /mminfo[^\u{00}]*?([\u{3b}\u{7c}\u{26}\u{60}]|\u{24}\u{28})/
(assert (str.in_re X (re.++ (str.to_re "/mminfo") (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "$(") (str.to_re ";") (str.to_re "|") (str.to_re "&") (str.to_re "`")) (str.to_re "/\u{0a}"))))
; (\d{3}.?\d{3}.?\d{3}-?\d{2})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9"))))))
; ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "."))) (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
