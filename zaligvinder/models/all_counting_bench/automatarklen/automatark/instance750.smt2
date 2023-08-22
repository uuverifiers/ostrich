(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Iterenetbadurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (str.to_re "Iterenetbadurl.grandstreetinteractive.com\u{0a}")))
; \+44\s\(0\)\s\d{2}\s\d{4}\s\d{4}
(assert (str.in_re X (re.++ (str.to_re "+44") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Referer\x3A\s+HXDownload\w+installs\x2Eseekmo\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HXDownload") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "installs.seekmo.com\u{0a}"))))
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}aom/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aom/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
