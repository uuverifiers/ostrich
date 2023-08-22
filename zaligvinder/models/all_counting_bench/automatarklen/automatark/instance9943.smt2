(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}psd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".psd/i\u{0a}"))))
; Toolbar\d+ServerLiteToolbardailywww\x2Ecameup\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbardailywww.cameup.com\u{13}\u{0a}"))))
; ^(([0-1][0-9]|2[0-3])[0-5][0-9]\-([0-1][0-9]|2[0-3])[0-5][0-9]|[C|c]losed)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.range "0" "5") (re.range "0" "9") (str.to_re "-") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (str.to_re "C") (str.to_re "|") (str.to_re "c")) (str.to_re "losed"))) (str.to_re "\u{0a}"))))
; /(USER|NICK)\u{20}BOSS\u{2d}[A-Z0-9\u{5b}\u{5d}\u{2d}]{15}/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "USER") (str.to_re "NICK")) (str.to_re " BOSS-") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "[") (str.to_re "]") (str.to_re "-"))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
