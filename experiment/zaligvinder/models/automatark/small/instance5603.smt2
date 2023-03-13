(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{0,5}[ ]{0,1}[0-9]{0,6}$
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 0 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{1,2}((,)|(,25)|(,50)|(,5)|(,75)|(,0)|(,00))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re ",25") (str.to_re ",50") (str.to_re ",5") (str.to_re ",75") (str.to_re ",0") (str.to_re ",00"))) (str.to_re "\u{0a}")))))
; ^[a-zA-Z]+((\s|\-|\')[a-zA-Z]+)?$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (re.union (str.to_re "-") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}")))))
; www\s+X-Mailer\u{3a}SpyBuddyUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}SpyBuddyUser-Agent:\u{0a}"))))
(check-sat)
