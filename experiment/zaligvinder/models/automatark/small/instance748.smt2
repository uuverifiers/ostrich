(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; xbqyosoe\u{2f}cpvmwww\u{2e}urlblaze\u{2e}netconfigINTERNAL\.ini
(assert (str.in_re X (str.to_re "xbqyosoe/cpvmwww.urlblaze.netconfigINTERNAL.ini\u{0a}")))
; \x7CConnected\s+adblock\x2Elinkz\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "|Connected") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adblock.linkz.com\u{0a}"))))
; [A-Za-z_.0-9-]+@{1}[a-z]+([.]{1}[a-z]{2,4})+
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (str.to_re "-"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.range "a" "z")) (re.+ (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.range "a" "z")))) (str.to_re "\u{0a}")))))
(check-sat)
