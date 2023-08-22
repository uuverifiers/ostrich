(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AUser-Agent\x3Awww\.take5bingo\.comUser-Agent\x3A
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:www.take5bingo.com\u{1b}User-Agent:\u{0a}")))
; ^(\s*\d\s*){11}$
(assert (not (str.in_re X (re.++ ((_ re.loop 11 11) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}")))))
; Host\x3A\dMicrosoft\w+\+Version\+
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Microsoft") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "+Version+\u{0a}")))))
; Spy\s+toolbar_domain_redirect
(assert (str.in_re X (re.++ (str.to_re "Spy") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "toolbar_domain_redirect\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
