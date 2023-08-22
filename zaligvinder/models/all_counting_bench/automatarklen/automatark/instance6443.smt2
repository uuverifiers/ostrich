(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; nick_name=CIA-Test\s+User-Agent\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddywww\x2Eeasymessage\x2Enet
(assert (not (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddywww.easymessage.net\u{0a}")))))
; www\x2Emakemesearch\x2EcomLOGOnevclxatmlhavj\u{2f}vsy
(assert (not (str.in_re X (str.to_re "www.makemesearch.comLOGOnevclxatmlhavj/vsy\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
