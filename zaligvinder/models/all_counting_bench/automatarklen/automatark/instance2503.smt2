(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Windows\d+BlackFiltereddaosearch\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Windows") (re.+ (re.range "0" "9")) (str.to_re "BlackFiltereddaosearch.com\u{0a}"))))
; /^\/[\w-]{48}\.[a-z]{2,8}[0-9]?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 8) (re.range "a" "z")) (re.opt (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; www\s+X-Mailer\u{3a}SpyBuddyUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}SpyBuddyUser-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
