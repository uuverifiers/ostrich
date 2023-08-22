(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}"))))
; /filename=[^\n]*\u{2e}qcp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qcp/i\u{0a}"))))
; /\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B(\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B){500}/m
(assert (not (str.in_re X (re.++ (str.to_re "/\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={") ((_ re.loop 500 500) (str.to_re "\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={")) (str.to_re "/m\u{0a}")))))
; HXLogOnlyDaemonactivityIterenetFrom\x3AClass
(assert (str.in_re X (str.to_re "HXLogOnlyDaemonactivityIterenetFrom:Class\u{0a}")))
(assert (< 200 (str.len X)))
(check-sat)
