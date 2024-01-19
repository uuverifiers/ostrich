(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <script[^>]*>[\w|\t|\r|\W]*</script>
(assert (str.in_re X (re.++ (str.to_re "<script") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re "|") (str.to_re "\u{09}") (str.to_re "\u{0d}") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</script>\u{0a}"))))
; Port\x2E[^\n\r]*007\d+Logsdl\x2Eweb-nexus\x2Enet
(assert (not (str.in_re X (re.++ (str.to_re "Port.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "007") (re.+ (re.range "0" "9")) (str.to_re "Logsdl.web-nexus.net\u{0a}")))))
; \|(http.*)\|(.*)$/ig
(assert (str.in_re X (re.++ (str.to_re "||") (re.* re.allchar) (str.to_re "/ig\u{0a}http") (re.* re.allchar))))
; Agent\s+Server\s+www\x2Einternet-optimizer\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Agent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.com\u{0a}"))))
; ^\d{10}$
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
