(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; configINTERNAL\.inikwdwww\x2Ewordiq\x2Ecomas\x2Estarware\x2Ecom
(assert (str.in_re X (str.to_re "configINTERNAL.inikwdwww.wordiq.com\u{1b}as.starware.com\u{0a}")))
; /filename=[^\n]*\u{2e}sum/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}"))))
; /SOAPAction\x3A\s*?\u{22}[^\u{22}\u{23}]+?\u{23}([^\u{22}]{2048}|[^\u{22}]+$)/Hsi
(assert (str.in_re X (re.++ (str.to_re "/SOAPAction:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.+ (re.union (str.to_re "\u{22}") (str.to_re "#"))) (str.to_re "#") (re.union ((_ re.loop 2048 2048) (re.comp (str.to_re "\u{22}"))) (re.+ (re.comp (str.to_re "\u{22}")))) (str.to_re "/Hsi\u{0a}"))))
; /(bot|spider|crawler|google)/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "bot") (str.to_re "spider") (str.to_re "crawler") (str.to_re "google")) (str.to_re "/\u{0a}"))))
(check-sat)
