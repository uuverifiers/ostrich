(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <textarea(.|\n)*?>((.|\n)*?)</textarea>
(assert (not (str.in_re X (re.++ (str.to_re "<textarea") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re ">") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</textarea>\u{0a}")))))
; /filename=[^\n]*\u{2e}wm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wm/i\u{0a}")))))
; /^Referer\u{3a}[^\r\n]+\/[\w_]{32,}\.html\r$/Hsm
(assert (str.in_re X (re.++ (str.to_re "/Referer:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/.html\u{0d}/Hsm\u{0a}") ((_ re.loop 32 32) (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (not (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; User-Agent\x3A\w+data2\.activshopper\.comdll\x3F
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.comdll?\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
