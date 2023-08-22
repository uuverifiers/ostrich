(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\\){2})(([A-Za-z ',.;]+)(\\?)([A-Za-z ',.;]\\?)*)$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "\u{5c}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";"))) (re.opt (str.to_re "\u{5c}")) (re.* (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";")) (re.opt (str.to_re "\u{5c}"))))))))
; /\/[a-zA-Z0-9]{4,10}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}"))))
; Reports[^\n\r]*User-Agent\x3A.*largePass-Onseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (re.++ (str.to_re "Reports") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "largePass-Onseqepagqfphv/sfd\u{0a}")))))
; ^[0-9]{5}([\s-]{1}[0-9]{4})?$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; aohobygi\u{2f}zwiwHost\u{3a}\x7D\x7Crichfind\x2Ecom
(assert (not (str.in_re X (str.to_re "aohobygi/zwiwHost:}|richfind.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
