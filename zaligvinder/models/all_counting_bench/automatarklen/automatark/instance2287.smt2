(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]:(\\|(\\[^\\/\s:*"<>|]+)+)>
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":") (re.union (str.to_re "\u{5c}") (re.+ (re.++ (str.to_re "\u{5c}") (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re ">\u{0a}")))))
; /^\/\d{9,10}\/1\d{9}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
; Toolbar\s+Host\x3A\w+Host\x3AEIcdpnode=reportUID\x2FServertoX-Mailer\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:EIcdpnode=reportUID/ServertoX-Mailer:\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}por/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".por/i\u{0a}"))))
; Subject\x3A\swww\x2Esearchwords\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.searchwords.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
