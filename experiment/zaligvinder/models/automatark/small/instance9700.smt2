(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\u{2e}urlblaze\u{2e}netCurrentHost\x3A
(assert (str.in_re X (str.to_re "www.urlblaze.netCurrentHost:\u{0a}")))
; /filename=[^\n]*\u{2e}mppl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mppl/i\u{0a}")))))
; /^SpyBuddy\s+Activity\s+Logs/smi
(assert (str.in_re X (re.++ (str.to_re "/SpyBuddy") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Activity") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Logs/smi\u{0a}"))))
; ^\\w*$
(assert (str.in_re X (re.++ (str.to_re "\u{5c}") (re.* (str.to_re "w")) (str.to_re "\u{0a}"))))
; /^.{9}[^\u{03}\u{0a}\u{11}\u{10}]/R
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 9 9) re.allchar) (re.union (str.to_re "\u{03}") (str.to_re "\u{0a}") (str.to_re "\u{11}") (str.to_re "\u{10}")) (str.to_re "/R\u{0a}")))))
(check-sat)
