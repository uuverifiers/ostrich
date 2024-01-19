(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SpyAgent\d+nick_name=CIA-Test\d+url=http\x3AHANDY\x2FNFO\x2CRegistered
(assert (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.range "0" "9")) (str.to_re "nick_name=CIA-Test") (re.+ (re.range "0" "9")) (str.to_re "url=http:\u{1b}HANDY/NFO,Registered\u{0a}"))))
; ^\d* \d*\/{1}\d*$|^\d*$
(assert (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re " ") (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ((\+44\s?\(0\)\s?\d{2,4})|(\+44\s?(01|02|03|07|08)\d{2,3})|(\+44\s?(1|2|3|7|8)\d{2,3})|(\(\+44\)\s?\d{3,4})|(\(\d{5}\))|((01|02|03|07|08)\d{2,3})|(\d{5}))(\s|-|.)(((\d{3,4})(\s|-)(\d{3,4}))|((\d{6,7})))
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "+44") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(0)") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9"))) (re.++ (str.to_re "+44") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "+44") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8")) ((_ re.loop 2 3) (re.range "0" "9"))) (re.++ (str.to_re "(+44)") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 4) (re.range "0" "9"))) (re.++ (str.to_re "(") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8"))) ((_ re.loop 5 5) (re.range "0" "9"))) (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 4) (re.range "0" "9"))) ((_ re.loop 6 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /^\u{2f}[0-9]{4,10}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 10) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; [1-8][0-9]{2}[0-9]{5}
(assert (str.in_re X (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
