(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[123456789]|1[0-2])(0[1-3]|1[0-9]|2[0-9]))|((0[13456789]|1[0-2])(30))|((0[13578]|1[02])(31))$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "3")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "30")) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "31")))))
; ^([^S]|S[^E]|SE[^P]).*
(assert (str.in_re X (re.++ (re.union (re.comp (str.to_re "S")) (re.++ (str.to_re "S") (re.comp (str.to_re "E"))) (re.++ (str.to_re "SE") (re.comp (str.to_re "P")))) (re.* re.allchar) (str.to_re "\u{0a}"))))
; alert\d+an.*Spyiz=e2give\.comrichfind\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "alert") (re.+ (re.range "0" "9")) (str.to_re "an") (re.* re.allchar) (str.to_re "Spyiz=e2give.comrichfind.com\u{0a}")))))
; User-Agent\x3A\s+information\swww\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "information") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
