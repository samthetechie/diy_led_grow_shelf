// Instructions.tsx — Simple folding and cutting guide for the DIY Grow Shelf zine

import React from "react";

export default function Instructions() {
  return (
    <div className="text-gray-800 mt-8 max-w-3xl mx-auto leading-relaxed">
      <h2 className="text-xl font-bold text-green-800 mb-4">
        How to Fold Your DIY Grow Shelf Zine
      </h2>
      <ol className="list-decimal list-inside space-y-2">
        <li>Print the zine double-sided on A4 paper (fit to page).</li>
        <li>Fold the paper in half widthwise, then again lengthwise.</li>
        <li>Cut along the center fold between the inner panels.</li>
        <li>Fold outward into an 8-page booklet.</li>
        <li>Trim edges if needed and enjoy your handmade publication!</li>
      </ol>
      <p className="mt-4 text-sm italic text-gray-600">
        Tip: Use recycled paper for sustainable printing.
      </p>
    </div>
  );
}
