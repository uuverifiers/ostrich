(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{2})?((\([0-9]{2})\)|[0-9]{2})?([0-9]{3}|[0-9]{4})(\-)?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (re.++ (str.to_re ")(") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\r\nReferer\x3A\u{20}http\x3A\x2F\u{2f}[a-z0-9\u{2d}\u{2e}]+\x2F\x3Fdo\x3Dpayment\u{26}ver\x3D\d+\u{26}sid\x3D\d+\u{26}sn\x3D\d+\r\n/H
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Referer: http://") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re "/?do=payment&ver=") (re.+ (re.range "0" "9")) (str.to_re "&sid=") (re.+ (re.range "0" "9")) (str.to_re "&sn=") (re.+ (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
; ((mailto\:|(news|(ht|f)tp(s?))\://){1}\S+)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (str.to_re "mailto:") (re.++ (re.union (str.to_re "news") (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (str.to_re "://")))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; /filename=[^\n]*\u{2e}cue/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cue/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
