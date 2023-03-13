(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\u{20}'\.]{8,64}[^\s]$
(assert (str.in_re X (re.++ ((_ re.loop 8 64) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "'") (str.to_re "."))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; [+]346[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "+346") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}opus/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".opus/i\u{0a}"))))
; Referer\x3Adialupvpn\u{5f}pwdwww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (str.to_re "Referer:dialupvpn_pwdwww.searchreslt.com\u{0a}"))))
; /^\/[0-9]{5}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
(check-sat)
