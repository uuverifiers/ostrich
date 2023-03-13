(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\"http:\/\/video\.google\.com\/googleplayer\.swf\?docId=\d{19}\&hl=[a-z]{2}\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://video.google.com/googleplayer.swf?docId=") ((_ re.loop 19 19) (re.range "0" "9")) (str.to_re "&hl=") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "\u{22}"))))
; /filename=[^\n]*\u{2e}fli/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}"))))
; /filename=[^\n]*\u{2e}emf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".emf/i\u{0a}"))))
; /\u{2e}appendChild.*?\u{2e}id.{0,200}?(offset|client)(Height|Left|Parent|Top|Width).{0,200}?(offset|client)(Height|Left|Parent|Top|Width)/is
(assert (not (str.in_re X (re.++ (str.to_re "/.appendChild") (re.* re.allchar) (str.to_re ".id") ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) (str.to_re "/is\u{0a}")))))
(check-sat)
