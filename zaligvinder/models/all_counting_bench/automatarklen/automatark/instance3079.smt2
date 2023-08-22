(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{1}-[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (\"http:\/\/video\.google\.com\/googleplayer\.swf\?docId=\d{19}\&hl=[a-z]{2}\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://video.google.com/googleplayer.swf?docId=") ((_ re.loop 19 19) (re.range "0" "9")) (str.to_re "&hl=") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "\u{22}"))))
; /Expression\u{28}\s*?GetClass\u{28}\u{22}sun.awt.SunToolkit\u{22}\u{29}\s*?,\s*?\u{22}getField\u{22}/smi
(assert (str.in_re X (re.++ (str.to_re "/Expression(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GetClass(\u{22}sun") re.allchar (str.to_re "awt") re.allchar (str.to_re "SunToolkit\u{22})") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}getField\u{22}/smi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
