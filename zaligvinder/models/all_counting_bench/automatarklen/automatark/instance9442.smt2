(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.getElements?By(Id|TagName)\u{28}\s*[\u{22}\u{27}]caption[\u{22}\u{27}]\s*\u{29}.*?innerHTML\s*\u{3d}\s*[\u{22}\u{27}]\u{3c}thead/sm
(assert (not (str.in_re X (re.++ (str.to_re "/.getElement") (re.opt (str.to_re "s")) (str.to_re "By") (re.union (str.to_re "Id") (str.to_re "TagName")) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "caption") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") (re.* re.allchar) (str.to_re "innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "<thead/sm\u{0a}")))))
; (\"http:\/\/www\.youtube\.com\/v\/\w{11}\&rel\=1\")
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://www.youtube.com/v/") ((_ re.loop 11 11) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&rel=1\u{22}")))))
; freeIPaddrsRunner\+The\+password\+is\x3A
(assert (not (str.in_re X (str.to_re "freeIPaddrsRunner+The+password+is:\u{0a}"))))
; ^[0-3]{1}[0-9]{1}[ ]{1}(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC|jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec){1}[ ]{1}[0-9]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec") (str.to_re "JAN") (str.to_re "FEB") (str.to_re "MAR") (str.to_re "APR") (str.to_re "MAY") (str.to_re "JUN") (str.to_re "JUL") (str.to_re "AUG") (str.to_re "SEP") (str.to_re "OCT") (str.to_re "NOV") (str.to_re "DEC") (str.to_re "jan") (str.to_re "feb") (str.to_re "mar") (str.to_re "apr") (str.to_re "may") (str.to_re "jun") (str.to_re "jul") (str.to_re "aug") (str.to_re "sep") (str.to_re "oct") (str.to_re "nov") (str.to_re "dec"))) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([0]{0,1}[0-7]{3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "0")) ((_ re.loop 3 3) (re.range "0" "7")))))
(assert (> (str.len X) 10))
(check-sat)
