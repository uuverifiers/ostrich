(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; logs\s+TCP.*Toolbarads\.grokads\.com
(assert (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TCP") (re.* re.allchar) (str.to_re "Toolbarads.grokads.com\u{0a}"))))
; (^(2014)|^(2149))\d{11}$
(assert (str.in_re X (re.++ (re.union (str.to_re "2014") (str.to_re "2149")) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{00}{7}\u{53}\u{00}{3}\u{16}.{8}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "S") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "\u{16}") ((_ re.loop 8 8) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}")))))
; /filename=[^\n]*\u{2e}aom/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aom/i\u{0a}")))))
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}"))))
(check-sat)
