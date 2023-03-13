(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d{9,10}\/1\/1\d{9}\.pdf$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".pdf/U\u{0a}")))))
; Reports[^\n\r]*User-Agent\x3A.*largePass-Onseqepagqfphv\u{2f}sfd
(assert (str.in_re X (re.++ (str.to_re "Reports") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "largePass-Onseqepagqfphv/sfd\u{0a}"))))
; <font[a-zA-Z0-9_\^\$\.\|\{\[\}\]\(\)\*\+\?\\~`!@#%&-=;:'",/\n\s]*>
(assert (not (str.in_re X (re.++ (str.to_re "<font") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "^") (str.to_re "$") (str.to_re ".") (str.to_re "|") (str.to_re "{") (str.to_re "[") (str.to_re "}") (str.to_re "]") (str.to_re "(") (str.to_re ")") (str.to_re "*") (str.to_re "+") (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "~") (str.to_re "`") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "%") (re.range "&" "=") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re ",") (str.to_re "/") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}")))))
(check-sat)
